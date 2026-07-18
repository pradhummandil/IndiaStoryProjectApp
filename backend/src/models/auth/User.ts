import mongoose, { Schema, type HydratedDocument } from 'mongoose';

export type UserRole = 'reader' | 'writer' | 'admin';

export interface User {
  name: string;
  username: string;
  email: string;
  passwordHash: string;
  avatarUrl?: string;
  role: UserRole;
  isVerified: boolean;
  createdAt: Date;
  updatedAt: Date;
}

type UserDocument = HydratedDocument<User>;

const UserSchema = new Schema<User>(
  {
    name: { type: String, required: true, trim: true, minlength: 1, maxlength: 120 },
    username: {
      type: String,
      required: true,
      trim: true,
      minlength: 3,
      maxlength: 50,
      unique: true,
      lowercase: true,
      index: true,
    },
    email: {
      type: String,
      required: true,
      trim: true,
      minlength: 3,
      maxlength: 254,
      unique: true,
      lowercase: true,
      index: true,
    },
    passwordHash: { type: String, required: true, minlength: 20, maxlength: 200 },
    avatarUrl: { type: String, required: false, default: '' },
    role: {
      type: String,
      required: true,
      enum: ['reader', 'writer', 'admin'],
      default: 'reader',
    },
    isVerified: { type: Boolean, required: true, default: false },
  },
  { timestamps: true },
);

// Security: never select password hash by default.
UserSchema.pre('find', function (next) {
  // eslint-disable-next-line @typescript-eslint/no-this-alias
  (this as any).select?.({ passwordHash: 0 });
  next();
});

export const UserModel = mongoose.model<UserDocument>('User', UserSchema);

